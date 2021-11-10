﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура устанавливает значения в регистр прав доступа по дереву.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
//  Дерево      - ДеревоЗначений.
// 
Процедура УстановитьЗначения(ВидОбъекта,Дерево)  Экспорт
	
	УстановитьЗначениеПоСтроке(ВидОбъекта,Дерево);
	
КонецПроцедуры // бит_УстановитьЗначения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает значения в регистр прав доступа по строке дерева значений. Рекурсия.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
//  СтрокаВерхняя - СтрокаДереваЗначений.
// 
Процедура УстановитьЗначениеПоСтроке(ВидОбъекта,СтрокаВерхняя)
	
	События = Обработки.бит_НастройкаПравДоступа.ОпределитьСобытия(ВидОбъекта);
	Если События = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Для каждого СтрокаДерева Из СтрокаВерхняя.ПолучитьЭлементы() Цикл
		
		Если СтрокаДерева.СтрокаОтредактирована Тогда
			МенеджерЗаписи = РегистрыСведений.бит_ПраваДоступа.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидОбъекта     = ВидОбъекта;
			МенеджерЗаписи.ОбъектДоступа  = СтрокаДерева.ОбъектДоступа;
			МенеджерЗаписи.ОбластьДоступа = СтрокаДерева.ОбластьДоступа;
			МенеджерЗаписи.СубъектДоступа = СубъектДоступа;
			ВсеЛожь = Истина;
			Для каждого ЗначениеПеречисления Из События Цикл
				ИмяЗначения = бит_ОбщегоНазначения.ПолучитьИмяЗначенияПеречисления(События,ЗначениеПеречисления);
				
				Если ИмяЗначения = "Печать" Тогда
				
					Продолжить;
				
				КонецЕсли; 
				
				МенеджерЗаписи[ИмяЗначения] = СтрокаДерева[ИмяЗначения];
				Если МенеджерЗаписи[ИмяЗначения] Тогда
					ВсеЛожь = Ложь;
				КонецЕсли; 
			КонецЦикла;
			Если НЕ ВсеЛожь Тогда
				МенеджерЗаписи.Записать();
			Иначе
				МенеджерЗаписи.Удалить();
			КонецЕсли; 
			
			СтрокаДерева.СтрокаОтредактирована = Ложь;
		КонецЕсли; 
		
		УстановитьЗначениеПоСтроке(ВидОбъекта,СтрокаДерева);
	КонецЦикла; 
	
КонецПроцедуры // бит_УстановитьЗначениеПоСтроке()

#КонецОбласти

#КонецЕсли
