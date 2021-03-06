
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТаблицаНастроек") Тогда
		
		ТЗ = Параметры.ТаблицаНастроек.Выгрузить();
		ТаблицаНастроек.Загрузить(ТЗ);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "КомандаОК".
// 
&НаКлиенте
Процедура КомандаОК(Команда)
	
	ном = 1;
	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		СтрокаТаблицы.КодСортировки = ном;
		ном = ном+1;
	
	КонецЦикла; 
	
	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("ТаблицаНастроек",ТаблицаНастроек);
	РезСтруктура.Вставить("Команда","ОК");
	
	Закрыть(РезСтруктура);
	
КонецПроцедуры

// Процедура - действие команды "КомандаУстановитьВсе".
// 
&НаКлиенте
Процедура КомандаУстановитьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		Если НЕ СтрокаТаблицы.ЗапретитьИзменятьВидимость Тогда
			
			СтрокаТаблицы.Видимость = Истина;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

// Процедура - действие команды "КомандаСнятьВсе".
// 
&НаКлиенте
Процедура КомандаСнятьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		Если НЕ СтрокаТаблицы.ЗапретитьИзменятьВидимость Тогда
			
			СтрокаТаблицы.Видимость = Ложь;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

// Процедура - действие команды "КомандаИнвертировать".
// 
&НаКлиенте
Процедура КомандаИнвертировать(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		Если НЕ СтрокаТаблицы.ЗапретитьИзменятьВидимость Тогда
			
			СтрокаТаблицы.Видимость = НЕ СтрокаТаблицы.Видимость;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти
