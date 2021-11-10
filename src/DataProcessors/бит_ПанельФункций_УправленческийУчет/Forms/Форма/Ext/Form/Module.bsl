﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	ЭтоСемействоЕРП = бит_ОбщегоНазначения.ЭтоСемействоERP();
	
	ПодключитьСхемы(ЭтоСемействоЕРП);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СхемаПараметрыУчетаВыбор(Элемент)
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));
КонецПроцедуры

&НаКлиенте
Процедура СхемаУчетНаПСВыбор(Элемент)
	
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	
	Если  Найти(ИмяЭлемента, "бит_ОткрытьПланыСчетов") Тогда
		// Сформируем список выбора планов счетов.
		СписокВыбора = СформироватьСписокОбъектовДляВыбораПланаСчетов();
	
    	ВыбранныйЭлемент = СписокВыбора.ВыбратьЭлемент("Выбор объекта: План счетов");
    
  	 	Если ВыбранныйЭлемент = Неопределено Тогда
   	    	Возврат;
  		КонецЕсли;
    
    	// Откроем форму списка выбранного плана счетов.
		ИмяОбъекта = ВыбранныйЭлемент.Значение;
		ПутьКФорме = "ПланСчетов." + ИмяОбъекта + ".ФормаСписка";
		
        ОткрытьФорму(ПутьКФорме);	
          		
    Иначе 
        
        Если Найти(ИмяЭлемента, "бит_ОткрытьЖурналыПроводок") Тогда
        
            // Сформируем список выбора регистров бухгалтерии.
            СписокВыбора = СформироватьСписокОбъектовДляВыбораЖурналовПроводок();

            ВыбранныйЭлемент = СписокВыбора.ВыбратьЭлемент("Выбор объекта: Регистр бухгалтерии");

            Если ВыбранныйЭлемент = Неопределено Тогда
                Возврат;
            КонецЕсли;
                
            // Откроем форму списка выбранного плана счетов.
            ИмяОбъекта = ВыбранныйЭлемент.Значение; 
            ПутьКФорме = "РегистрБухгалтерии." + ИмяОбъекта + ".ФормаСписка";
            ОткрытьФорму(ПутьКФорме);	
            
		Иначе		
            
            бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));		
            
        КонецЕсли; 
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура СхемаЗакрытиеСчетовВыбор(Элемент)
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));
КонецПроцедуры

&НаКлиенте
Процедура СхемаПанельИндикаторовВыбор(Элемент)
	ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНажатие(Элемент)

	ИмяЭлемента = Элемент.Имя;
	// Для дублирующихся элементов убираем номер из имени.
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_ФормаСписка1","_ФормаСписка");	
	ИмяЭлемента = СтрЗаменить(ИмяЭлемента, "_Форма1","_Форма");
	бит_РаботаСДиалогамиКлиент.ОткрытьФормуПоИмени(ИмяЭлемента, Новый Структура("ПреобразоватьИзИмени",Истина));
	
КонецПроцедуры	

// Формирует список имен планов счетов БИТ.
// 
&НаСервере
Функция СформироватьСписокОбъектовДляВыбораПланаСчетов()
	
	СписокВыбора = бит_УправленческийУчет.СформироватьСписокОбъектовДляВыбора(Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов, "бит_Дополнительный");
	
	Для Каждого ТекЭлемент Из СписокВыбора Цикл
		ТекЭлемент.Значение = ТекЭлемент.Значение.ИмяОбъекта;
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции // СформироватьСписокОбъектовДляВыбора()

&НаСервере
Функция СформироватьСписокОбъектовДляВыбораЖурналовПроводок()
	
	СписокВыбора = бит_УправленческийУчет.СформироватьСписокОбъектовДляВыбора(Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии, "бит_Дополнительный");
	
	Для Каждого ТекЭлемент Из СписокВыбора Цикл
		ТекЭлемент.Значение = ТекЭлемент.Значение.ИмяОбъекта;
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции // СформироватьСписокОбъектовДляВыбора()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура подключает макеты-схемы.
// 
// Параметры:
//  ЭтоСемействоЕРП - Булево
//
&НаСервере
Процедура ПодключитьСхемы(ЭтоСемействоЕРП)
	
	ИмяСхемыУПС = ?(ЭтоСемействоЕРП, "СхемаУчетНаПланеСчетов_ЕРП", "СхемаУчетНаПланеСчетов");
	
	// Устанавливаем графические схемы
	СхемаПараметрыУчета    = Обработки.бит_ПанельФункций_УправленческийУчет.ПолучитьМакет("СхемаПараметрыУчета");
	СхемаУчетНаПланеСчетов = Обработки.бит_ПанельФункций_УправленческийУчет.ПолучитьМакет(ИмяСхемыУПС);
	СхемаЗакрытиеСчетов    = Обработки.бит_ПанельФункций_УправленческийУчет.ПолучитьМакет("СхемаЗакрытиеСчетов");
	СхемаПанельИндикаторов = Обработки.бит_ПанельФункций_УправленческийУчет.ПолучитьМакет("СхемаПанельИндикаторов");
	
КонецПроцедуры// ПодключитьСхемы()

#КонецОбласти
