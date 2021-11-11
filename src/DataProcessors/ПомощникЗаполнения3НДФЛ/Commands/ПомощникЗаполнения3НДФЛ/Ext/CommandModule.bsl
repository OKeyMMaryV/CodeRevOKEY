﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Обработка.ПомощникЗаполнения3НДФЛ.Форма", ПараметрыПомощника());
	
КонецПроцедуры

&НаСервере
Функция ПараметрыПомощника()
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("КонтекстныйВызов", Ложь);
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Если ЗначениеЗаполнено(ОсновнаяОрганизация) И Не ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ОсновнаяОрганизация) Тогда
		ПараметрыПомощника.Вставить("Организация", ОсновнаяОрганизация);
	КонецЕсли;
	
	ПрошлыйГод = НачалоГода(ДобавитьМесяц(ОбщегоНазначения.ТекущаяДатаПользователя(), -12));
	Период = Макс(ПрошлыйГод, Обработки.ПомощникЗаполнения3НДФЛ.ДатаНачалаПрименения());
	ПараметрыПомощника.Вставить("Период", Период);
	
	ВыбраннаяФорма = Отчеты.РегламентированныйОтчет3НДФЛ.ФормаПоУмолчанию(Период);
	ПараметрыПомощника.Вставить("ВыбраннаяФорма", ВыбраннаяФорма);
	
	Возврат ПараметрыПомощника;
	
КонецФункции

#КонецОбласти