using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace Colonos.Web.Content.Utilidades
{
    public static class Utility
    {
        /// <summary>
        /// Used to get method information using reflection
        /// </summary>
        public static MethodInfo GetCompareToMethod<T>(T genericInstance, string sortExpression)
        {
            Type genericType = genericInstance.GetType();
            object sortExpressionValue = genericType.GetProperty(sortExpression).GetValue(genericInstance, null) ?? "" ;
            Type sortExpressionType = sortExpressionValue.GetType();
            MethodInfo compareToMethodOfSortExpressionType = sortExpressionType.GetMethod("CompareTo", new Type[] { sortExpressionType });
            return compareToMethodOfSortExpressionType;
        }

        public static List<T> DynamicSort1<T>(List<T> genericList, string sortExpression, string sortDirection)
        {
            try
            {
                int sortReverser = sortDirection.ToLower().StartsWith("asc") ? 1 : -1;
                Comparison<T> comparisonDelegate = new Comparison<T>((x, y) =>
                {
                // Just to get the compare method info to compare the values.
                    MethodInfo compareToMethod = GetCompareToMethod<T>(x, sortExpression);
                // Getting current object value.
                    object xSortExpressionValue = x.GetType().GetProperty(sortExpression).GetValue(x, null) ?? "";
                // Getting the previous value.
                    object ySortExpressionValue = y.GetType().GetProperty(sortExpression).GetValue(y, null) ?? "";
                // Comparing the current and next object value of collection.
                    object result = compareToMethod.Invoke(xSortExpressionValue, new object[] { ySortExpressionValue });
                // Result tells whether the compared object is equal, greater, or lesser.
                    return sortReverser * Convert.ToInt16(result);
                });
                // Using the comparison delegate to sort the object by its property.
                genericList.Sort(comparisonDelegate);
            }
            catch
            {

            }
            return genericList;
        }
    }
}