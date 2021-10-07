﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Проверки = БухгалтерскиеОтчетыВызовСервера.СтандартныеПроверкиЗаполнения();
	Проверки.Вставить("СписокВидовСубконто", Истина);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Проверки);
	
	Если СписокВидовСубконто.Количество() > 0
	   И Не ЗначениеЗаполнено(СписокВидовСубконто[0].Значение) Тогда
	   
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Вид субконто"" не заполнено.'"), , "ВидСубконто", , Отказ);
			
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполненияОтборов(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли