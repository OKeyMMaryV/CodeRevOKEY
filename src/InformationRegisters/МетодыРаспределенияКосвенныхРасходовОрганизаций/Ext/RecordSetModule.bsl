#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОшибкиНесовпаденияПодразделений = Новый Массив;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.БазаРаспределения = Перечисления.БазыРаспределенияКосвенныхРасходов.Выручка
			И Запись.СчетЗатрат = ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы Тогда
			
			СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Запись.СчетЗатрат);
			
			Если СвойстваСчета.УчетПоПодразделениям 
				И ЗначениеЗаполнено(Запись.ПодразделениеЗатрат)
				И Запись.ПодразделениеЗатрат <> Запись.Подразделение Тогда
				ОшибкиНесовпаденияПодразделений.Добавить(Запись);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОшибкиНесовпаденияПодразделений.Количество() > 0 Тогда 
		
		ОписаниеКлючаЗаписи = Новый Структура; // Для навигации в сообщении об ошибке
		Для Каждого Измерение Из Метаданные.РегистрыСведений.МетодыРаспределенияКосвенныхРасходовОрганизаций.Измерения Цикл
			ОписаниеКлючаЗаписи.Вставить(Измерение.Имя);
		КонецЦикла;
		
		Для Каждого Ошибка Из ОшибкиНесовпаденияПодразделений Цикл
			
			ТекстСообщения =  НСтр("ru = 'Укажите одинаковые значения в полях ""Подразделение"" и 
				|""Подразделение затрат"", т.к. общепроизводственные расходы распределяются в рамках одного подразделения.'");
			
			ЗаполнитьЗначенияСвойств(ОписаниеКлючаЗаписи, Ошибка);
			КлючЗаписи = РегистрыСведений.МетодыРаспределенияКосвенныхРасходовОрганизаций.СоздатьКлючЗаписи(ОписаниеКлючаЗаписи);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючЗаписи, , , Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
