﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Шаблоны") Тогда
	
		Для каждого ТекШаблон Из Параметры.Шаблоны Цикл
		
			НоваяСтрока = Объект.Шаблоны.Добавить();
			НоваяСтрока.Шаблон = ТекШаблон;
		
		КонецЦикла; 
	
	КонецЕсли; 
	
	фКэшЗначений = Новый Структура;
	
	// Заполним список типов для быстрого выбора составного.
	МассивТипов  = Метаданные.Обработки.бит_НастройкаПравДоступа.ТабличныеЧасти.Шаблоны.Реквизиты.Шаблон.Тип.Типы();
	СписокВыбора = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	фКэшЗначений.Вставить("СписокТиповШаблон", СписокВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШаблоныШаблонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Шаблоны.ТекущиеДанные;
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,ТекущаяСтрока
	                                                   ,"Шаблон"
													   ,фКэшЗначений.СписокТиповШаблон
													   ,СтандартнаяОбработка);
													   
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныШаблонОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.ШаблоныШаблон.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	РезСтр = Новый Структура;
	Шаблоны = Новый Массив;
	Для каждого ТекСтрока Из Объект.Шаблоны Цикл
	
		Шаблоны.Добавить(ТекСтрока.Шаблон);
	
	КонецЦикла; 
	
	РезСтр.Вставить("Шаблоны", Шаблоны);
	
	Закрыть(РезСтр);
	
КонецПроцедуры

#КонецОбласти



