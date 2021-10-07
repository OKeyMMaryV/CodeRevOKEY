﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С РЕДАКТОРОМ ФОРМУЛ.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Процедура открывает редактор формул.
// 
// Параметры:
//  ЭтаФорма 				 - УправляемаяФорма
//  ЗаголовокРедактораФормул - Строка.          
// 
Процедура рф_ОткрытьСервер(ЭтаФорма, ЗаголовокРедактораФормул) Экспорт
	
	Элементы = ЭтаФорма.Элементы;
	
	Элементы.ГруппаРедакторФормул.Заголовок = ЗаголовокРедактораФормул;
	Элементы.ГруппаРедакторФормул.Видимость = Истина;
	
	ЭтаФорма.рфРедакторФормулОткрыт 		   = Истина;	
	ЭтаФорма.рфПерваяАктивизацияПоляПолучателя = Истина;
	
	Элементы.РедакторФормул_ОК.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры // Рф_Открыть()

// Процедура закрывает редактор формул.
// 
// Параметры: 
//  ЭтаФорма - УправляемаяФорма.
// 
Процедура рф_ЗакрытьСервер(ЭтаФорма) Экспорт

	Элементы = ЭтаФорма.Элементы;
	
	Элементы.ГруппаРедакторФормул.Видимость 	     = Ложь; 
	Элементы.ФормаЗаписатьИЗакрыть.КнопкаПоУмолчанию = Истина;
	
	ЭтаФорма.рфРедакторФормулОткрыт 	= Ложь;
	
	ЭтаФорма.рфЭтоДобавление = Ложь;
	ЭтаФорма.рфФормула		= "";
	ЭтаФорма.рфСтараяФормула = "";
	
	//Элементы.рфСтрокаНазад.СписокВыбора.Очистить();
	
КонецПроцедуры // Рф_ЗакрытьСервер()
  
// Процедура заполняет группу на форме "ГруппаРедакторФормул".
// 
// Параметры:
//  ЭтаФорма  - УправляемаяФорма
//  ЕстьМакет - Булево (По умолчанию = Ложь).
// 
Процедура рф_ИнициализацияРедактораФормул(ЭтаФорма, ЕстьМакет = Ложь) Экспорт
	
	Элементы = ЭтаФорма.Элементы;
	Команды  = ЭтаФорма.Команды;
	
	// ----------------------------------------------------------------------
	// Реквизиты формы
	ОП_Строка = Новый ОписаниеТипов("Строка");
	ОП_Булево = Новый ОписаниеТипов("Булево");
	ОП_ТЗ     = Новый ОписаниеТипов("ТаблицаЗначений");
	
	// Новые реквизиты формы		
	РеквизитыРФ = Новый Массив;
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфРедакторФормулОткрыт", ОП_Булево, , "Редактор формул открыт"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфФормула"			 , ОП_Строка, , "Формула"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфСтараяФормула"		 , ОП_Строка, , "Старая формула"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфЭтоДобавление"		 , ОП_Булево, , "Это добавление"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфСтрокаНазад"		 , ОП_Строка, , "Строка возврата"));
	// Если ЕстьМакет Тогда
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфИмяОбластиПолучатель"			, ОП_Строка, 					 , "Имя области - получателя"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфВыбранныеОбласти"	  			, ОП_ТЗ    , 					 , "Выбранные области"));
	РеквизитыРФ.Добавить(Новый РеквизитФормы("ИмяОбласти"			  			, ОП_Строка, "рфВыбранныеОбласти", "Выбранные области"));
	// Изменение кода. Начало. 11.12.2013{{
	РеквизитыРФ.Добавить(Новый РеквизитФормы("ЗаголовокОбласти"                 , ОП_Строка, "рфВыбранныеОбласти", "Выбранные области"));
	// Изменение кода. Конец. 11.12.2013}}
	РеквизитыРФ.Добавить(Новый РеквизитФормы("рфПерваяАктивизацияПоляПолучателя", ОП_Булево, 					 , "Это первая активизация поля-получателя"));
	// КонецЕсли;	
	
	ЭтаФорма.ИзменитьРеквизиты(РеквизитыРФ);
	
	бит_РедакторФормулСервер.рф_ДобавитьЭлементыРедактораФормул(Элементы, Команды); 		
		          	
КонецПроцедуры // Рф_ИнициализацияРедактораФормул()

#КонецОбласти
