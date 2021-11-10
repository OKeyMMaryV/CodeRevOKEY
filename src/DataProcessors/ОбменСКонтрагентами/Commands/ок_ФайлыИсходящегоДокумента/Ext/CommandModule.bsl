﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ПоказатьПредупреждение(, "Перед данным действием необходимо записать документ");
		Возврат;
	КонецЕсли;	
	ПараметрыФормы = Новый Структура("Документ", ПараметрКоманды);
	ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ок_ФормаПросмотраИсходящегоДокумента", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
