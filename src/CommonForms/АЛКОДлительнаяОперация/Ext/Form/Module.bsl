﻿
////////////////////////////////////////////////////////////////////////////////
//
// Параметры формы:
//
//	 	СообщениеПользователю 				- Строка - Необязательный. Основное сообщение, выводимое в форме 
//												длительной операции.
// 		ДопСообщениеПользователю 				- Строка - Необязательный. Дополнительное сообщение, выводимое после основного, 
//												с новой строки.
// 		ДоступностьКнОтмена					- Булево - Необязательный. Определяет доступность и видимость кнопки "Отмена" 
//												на форме длительной операции.
// 		ВидимостьПроцентВыполнения		 	- Булево - Необязательный. Определяет видимость шкалы прогресса
//												с процентом выполнения.
// 		ПроцентВыполнения		 			- Число - Необязательный. Процент выполнения длительной операции, 
//												который надо показать. Данное свойство учитывается только если передано
//												свойство ВидимостьПроцентаВыполненияОперации.
//		УникальностьФормы					- Уникальный идентификатор формы.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РегламентированнаяОтчетностьАЛКО.УдалитьНастройкиОкнаФормы(ЭтаФорма);
		
	Если Параметры.Свойство("УникальностьФормы") Тогда
		Если ЗначениеЗаполнено(Параметры.УникальностьФормы) Тогда
			УникальностьФормы = Параметры.УникальностьФормы;
		КонецЕсли;
	КонецЕсли;
	
	СообщениеПользователю = НСтр("ru = 'Пожалуйста, подождите...'");
	
	ОбработкаПараметровНаСервере(Параметры); 
	
	МожноЗакрыть = Элементы.КнФормаОтмена.Доступность;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
		
	// Если нет разрешения на закрытие - не дадим закрыть. 		
	Если Не МожноЗакрыть Тогда
	    Отказ = Истина;		
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
	    Отказ = Истина;
		ТекстПредупреждения = НСтр("ru='Данная форма вспомогательная, предназначена для 
										|демонстрации хода процесса длительной операции
										|из форм регламентированных отчетов!'");
		ПоказатьПредупреждение(, ТекстПредупреждения, , НСтр("ru='Форма длительных операций.'"));
		Возврат;	
	КонецЕсли;
	
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	Если Источник = УникальностьФормы Тогда
	
		Если НРег(ИмяСобытия) = НРег("ЗакрытьДлительнуюОперацию") Тогда			
			
			МожноЗакрыть = Истина;
			Модифицированность = Ложь;
			Если Открыта() Тогда				
				Закрыть();			
			КонецЕсли;						
						
		ИначеЕсли НРег(ИмяСобытия) = НРег("ИмитацияАктивности") Тогда
			
			ОбработкаПараметровНаСервере(Параметр);
			ОбновитьОтображениеДанных();			
			Активизировать();
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменаОперации(Команда)
	
	МожноЗакрыть = Истина;
	Модифицированность = Ложь;
	
	// Оповещаем форму отчета владельца о том, что длительная операция отменена.
	Оповестить("ОтменаОперации", , УникальностьФормы);
	
	// При отмене длительной операции копирования отчета,
	// отчет закрывается быстрее формы длительной операции,
	// и закрывает эту форму как владелец,
	// если нет проверки на открытость - возникает ошибка.
	Если Открыта() Тогда
	    Закрыть();	
	КонецЕсли; 
				
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработкаПараметровНаСервере(Параметр)
	
	Если Параметр <> Неопределено Тогда
				
		Если ПроцентВыполнения = Неопределено Тогда
		    ПроцентВыполнения = 0;		
		КонецЕсли;
		
		Если Параметр.Свойство("ПроцентВыполнения") Тогда
			
			ПроцВыполнения = Параметр.ПроцентВыполнения;
			Если НЕ ЗначениеЗаполнено(ПроцВыполнения) Тогда
			    ПроцВыполнения = 0;					
			КонецЕсли;
			
			Если ПроцентВыполнения = 0 и ПроцВыполнения > 0 Тогда
			    // Фиксируем начало работы.
				ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();				
			    ТекущееВремя = ВремяНачала;
			КонецЕсли;
			
			Если ПроцентВыполнения > 0 Тогда
			
				ТекВремя = ТекущаяУниверсальнаяДатаВМиллисекундах();
				ТекДата  = ТекущаяДатаСеанса();
				
				Если ТекВремя - ВремяНачала > 30000 Тогда
				    // Операция идет больше минуты, посчитаем время завершения.
					РазницаВПроцентах = ПроцВыполнения - ПроцентВыполнения;
					Если РазницаВПроцентах > 0 Тогда
					
						РазницаВМиллисекундах = ТекВремя - ТекущееВремя;
						ОсталосьВремениВМиллисекундах = (100 - ПроцВыполнения) * (РазницаВМиллисекундах/РазницаВПроцентах);
						ОсталосьВремениВСекундах = Окр(ОсталосьВремениВМиллисекундах/1000);
						
						ДатаЗавершения = ТекДата + ОсталосьВремениВСекундах;
						
						ВремяВыполнения = "Примерное время завершения: " + ДатаЗавершения;	
					
					КонецЕсли; 
				    
				КонецЕсли; 
			
			КонецЕсли; 
			
			ТекущееВремя = ТекущаяУниверсальнаяДатаВМиллисекундах();
			
			ОкруглитьДоСотых = (ПроцВыполнения - ПроцентВыполнения < 2);
						
			ПроцентВыполнения = ПроцВыполнения;
			ПроцентВыполненияПрогресс = 100 * ПроцентВыполнения;
			
		КонецЕсли;
				
		Если Параметр.Свойство("ВидимостьПроцентВыполнения") Тогда	
			
			Элементы.ПроцентВыполнения.Видимость 		= Параметр.ВидимостьПроцентВыполнения;						
			Элементы.ДекорацияКомпенсацияВысотыШкалаПрогресса.Видимость = НЕ Параметр.ВидимостьПроцентВыполнения;
			
		КонецЕсли;
		
		Если Элементы.ПроцентВыполнения.Видимость Тогда
		    
			ПроцентВыполнения = ?(ПроцентВыполнения = Неопределено, 0, ПроцентВыполнения);
			ПроцентВыполненияНадпись = ?(ПроцентВыполнения = 0, "", "" + ?(ОкруглитьДоСотых, Окр(Число(ПроцентВыполнения), 2), Окр(Число(ПроцентВыполнения))) + " %");
		Иначе
			ПроцентВыполненияНадпись = "";
			ВремяВыполнения = "";
			ВремяНачала 	= Неопределено;
			ТекущееВремя 	= Неопределено;
			ПроцентВыполнения = 0;
		КонецЕсли;
		
		Если Параметр.Свойство("СообщениеПользователю") и ЗначениеЗаполнено(Параметр.СообщениеПользователю) Тогда
			
			ОсновноеСообщениеПользователю = Параметр.СообщениеПользователю;
			
		КонецЕсли;
		
		Если Параметр.Свойство("ДопСообщениеПользователю") и ЗначениеЗаполнено(Параметр.ДопСообщениеПользователю) Тогда
			
			ДопСообщениеПользователю = Параметр.ДопСообщениеПользователю;
			
		ИначеЕсли Параметр.Свойство("ДопСообщениеПользователю") и Параметр.ДопСообщениеПользователю = Неопределено Тогда
			
			ДопСообщениеПользователю = "";
			
		КонецЕсли;
		
		СообщениеПользователю = "" + ОсновноеСообщениеПользователю 
								+ ?(ЗначениеЗаполнено(ДопСообщениеПользователю), "
									|" + ДопСообщениеПользователю, "");
		
		Если Параметр.Свойство("ДоступностьКнОтмена") Тогда
			
		    Элементы.КнФормаОтмена.Доступность = Параметр.ДоступностьКнОтмена;	
			Элементы.КнФормаОтмена.Видимость = Параметр.ДоступностьКнОтмена;
			
		КонецЕсли;
				
	КонецЕсли;
				
КонецПроцедуры

#КонецОбласти

